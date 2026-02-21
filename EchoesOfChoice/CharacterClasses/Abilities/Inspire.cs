using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Inspire : Ability
    {
        public Inspire()
        {
            Name = "Inspire";
            FlavorText = "Motivate a teammate. Increases attacks.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 7;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
