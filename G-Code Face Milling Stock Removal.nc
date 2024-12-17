using System;

public class Program
{
	public static void Main()
	{
		// setting variables for calculations
		Console.WriteLine("What is your starting point in Z?");
		double startZ = double.Parse(Console.ReadLine());
		Console.WriteLine("What is your tool number?");
		double toolNum = double.Parse(Console.ReadLine());
		Console.WriteLine("What is your tool offset number?");
		double offsetNum = double.Parse(Console.ReadLine());
		Console.WriteLine("What is your facemill diameter?");
		double facemillDia = double.Parse(Console.ReadLine());
		Console.WriteLine("What is your desired stock removal?");
		double faceStock = double.Parse(Console.ReadLine());
		Console.WriteLine("What is your desired depth of cut?");
		double depthCut = double.Parse(Console.ReadLine());
		Console.WriteLine("What is your part width(Y)?");
		double yWidth = double.Parse(Console.ReadLine());
		Console.WriteLine("What is your part length(X)?");
		double xWidth = double.Parse(Console.ReadLine());
		Console.WriteLine("What is desired RPM?");
		double rpm = double.Parse(Console.ReadLine());
		Console.WriteLine("What is desired feed in IPM?");
		double feedRate = double.Parse(Console.ReadLine());
		Console.WriteLine("What is your desired retract height?");
		double retractHeight = double.Parse(Console.ReadLine());
		Console.WriteLine("What is the last four numbers of your part number?");
		double partNum = double.Parse(Console.ReadLine());
		//start calculation variables
		double yApproach = facemillDia / 2 + .1;
		double yFinish = yApproach + yWidth;
		double xApproach = facemillDia / 2 + .1;
		double xFinish = xApproach + xWidth;
		double zApproach = startZ + .1;
		double stepover = facemillDia * .60;
		double depthPasses = faceStock / depthCut;
		double widthPasses = yWidth / stepover;
		double currentDepth = depthCut, currentY = yApproach, wp = 0, cy = 0, my = 0;
		double maxY = stepover + yWidth;
		
		// start writing program
		Console.WriteLine("");
		Console.WriteLine("%");
		Console.WriteLine("O0" + partNum + ";");
		Console.WriteLine("(Probe XY minus);");
		Console.WriteLine("T" + toolNum + " M06" + "(" + facemillDia.ToString("F4") + " Facemill);");
		Console.WriteLine("(Face Stock Removal W/" + facemillDia.ToString("F4") + " Facemill)");
		Console.WriteLine("G90 G43 G0 G54 X" + yApproach.ToString("F4") + " Y-" + yApproach.ToString("F4") + " Z" + retractHeight.ToString("F4") + " H" + toolNum + " S" + rpm + " M3;");
		Console.WriteLine("G0 Z" + zApproach.ToString("F4") + ";");
		Console.WriteLine(";");
		
		// iterates through depth passes and writes lines
		for (double z = depthPasses, y = widthPasses, cd = currentDepth; z > 0; z--)
		{
			if (cd > faceStock)
			{
				cd = faceStock;
			}

			// iterates through y passes and writes lines
			for (wp = widthPasses, cy = currentY, my = maxY; wp > 0; wp--)
			{
				Console.WriteLine("G1 Z-" + cd.ToString("F4") + " F" + feedRate.ToString("F2") + ";");
				Console.WriteLine("G1 X-" + xFinish.ToString("F4") + " Y-" + cy.ToString("F4") + ";");
				Console.WriteLine("G0 Z" + currentDepth + ";");
				cy += stepover;
				Console.WriteLine("G0 X" + xApproach + " Y-" + cy.ToString("F4") + ";");
				Console.WriteLine(";");
				if (cy > maxY)
				{
					cy = maxY;
				}
			}

			cd += depthCut;
			if (cd > faceStock)
			{
				cd = faceStock;
			}
		}

		Console.WriteLine("G0 Z" + retractHeight.ToString("F4") + ";");
		Console.WriteLine("G59 X0. Y0.;");
		Console.WriteLine("M30");
		Console.WriteLine("%");
	}
}