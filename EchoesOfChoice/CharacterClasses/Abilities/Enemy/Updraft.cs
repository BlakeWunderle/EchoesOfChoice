using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Updraft : Ability
    {
        public Updraft()
        {
            Name = "Updraft";
            FlavorText = "Howling winds amplify every strike.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
