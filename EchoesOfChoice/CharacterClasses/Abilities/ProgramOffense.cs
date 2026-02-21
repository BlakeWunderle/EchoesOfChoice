using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class ProgramOffense : Ability
    {
        public ProgramOffense()
        {
            var random = new System.Random();
            Name = "Program Offense";
            FlavorText = "Hack your own systems to overclock weapons. Results may vary.";
            ModifiedStat = StatEnum.Attack;
            Modifier = random.Next(-3, 10);
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = random.Next(3, 7);
        }
    }
}
