using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Bravado : Ability
    {
        public Bravado()
        {
            Name = "Bravado";
            FlavorText = "A roaring battle cry that steels the Captain's resolve.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 2;
        }
    }
}
