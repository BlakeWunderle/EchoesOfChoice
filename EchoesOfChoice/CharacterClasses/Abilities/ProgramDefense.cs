using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class ProgramDefense : Ability
    {
        public ProgramDefense()
        {
            var random = new System.Random();
            Name = "Program Defense";
            FlavorText = "Feeling lucky today? Increases defense.";
            ModifiedStat = StatEnum.Defense;
            Modifier = random.Next(-5, 10);
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = random.Next(3, 7);
        }
    }
}
